DECRYPT=     ./secret -d
ENCRYPT=     ./secret
RESTART=     ./restart.sh
PLAN=        tfplan
PLAINTEXT=   secrets.auto.tfvars
ENCRYPTED=   ${PLAINTEXT}.enc
TF=          terraform

all: login apply clean

clean:
	@rm -f ${PLAINTEXT} ${PLAN}

plan: ${PLAN}

${ENCRYPTED}: encrypt
${PLAINTEXT}: decrypt

${PLAN}: ${PLAINTEXT}
	@-echo "Validating ..."
	@${TF} validate
	@-echo "Creating ${PLAN} ..."
	@${TF} plan -out=${PLAN} -input=false

login:
	@-echo "Azure Login ..."
	@az login --service-principal -u ${ARM_CLIENT_ID} -p ${ARM_CLIENT_SECRET} --tenant ${ARM_TENANT_ID}

decrypt:
	@-echo "Decrypting ${ENCRYPTED} > ${PLAINTEXT} ..."
	@${DECRYPT} ${ENCRYPTED} > ${PLAINTEXT}

encrypt:
	@-echo "Encrypting ${PLAINTEXT} > ${ENCRYPTED} ..."
	${ENCRYPT} ${PLAINTEXT} > ${ENCRYPTED}

init:
	@-echo "Initialising ..."
	@${TF} init -input=false

apply: ${PLAN}
	@-echo "Applying ${PLAN} ..."
	@${TF} apply -input=false -auto-approve tfplan

restart:
	@-echo "account: ${account}"
	@-echo "environment: ${environment}"
	@-echo "date: ${date}"
	
	${RESTART} ${account} ${environment} ${date}
