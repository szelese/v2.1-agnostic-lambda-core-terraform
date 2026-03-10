FROM public.ecr.aws/lambda/python:3.12

# Dependencies, changed infrequently=top layer
COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip install -r requirements.txt

# Source code, changed frequently=bottom layer
COPY src/ ${LAMBDA_TASK_ROOT}/src/

# Handler
CMD [ "src.main.handler" ]