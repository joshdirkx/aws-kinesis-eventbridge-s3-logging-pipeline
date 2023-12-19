FROM public.ecr.aws/lambda/ruby:latest
# Assuming you're using Ruby as per your previous request

# Copy function code and any required files
COPY app.rb ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler
CMD ["app.lambda_handler"]
