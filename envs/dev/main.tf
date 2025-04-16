
provider "aws" {
  region  = "ap-south-1"
}

module "iam" {
  source    = "../../modules/iam"
  role_name = "weconnect-lambda-role-dev"
  tags = {
    Project     = "Weconnect-Scheduler"
    Environment = "dev"
  }
}

module "lambda_setup_mfa" {
  source           = "../../modules/lambda"
  function_name    = "MFASetup"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/setup_mfa.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_list_users" {
  source           = "../../modules/lambda"
  function_name    = "listUserDataFunction"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/list_users.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_update_user" {
  source           = "../../modules/lambda"
  function_name    = "editUserDataFunction"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/update_user.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_delete_user" {
  source           = "../../modules/lambda"
  function_name    = "deleteUserDataFunction"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/delete_user.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_get_user_mfa" {
  source           = "../../modules/lambda"
  function_name    = "get-user-mfa"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/get_user_mfa.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_add_user" {
  source           = "../../modules/lambda"
  function_name    = "saveUserDataFunction"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/add_user.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_delete_user_mfa" {
  source           = "../../modules/lambda"
  function_name    = "delete-user-mfa"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/delete_user_mfa.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_get_user_by_id" {
  source           = "../../modules/lambda"
  function_name    = "get-user-by-id"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/get_user_by_id.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_validate_user" {
  source           = "../../modules/lambda"
  function_name    = "uservalidate"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/validate_user.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "lambda_verify_mfa" {
  source           = "../../modules/lambda"
  function_name    = "verifyMFA"
  handler          = "index.handler"
  lambda_zip_path  = "../../lambda-code/verify_mfa.zip"
  lambda_role_arn  = module.iam.lambda_exec_role_arn
  env_vars         = { STAGE = "dev" }
  tags             = { Project = "Weconnect-Scheduler", Environment = "dev" }
}

module "api_gateway" {
  source = "../../modules/multi-lambda-api-gateway"
  name   = "weconnect-api-dev"

  routes = {
    "/setup-mfa"        = { method = "POST", lambda_uri = module.lambda_setup_mfa.lambda_uri },
    "/user/list"        = { method = "POST", lambda_uri = module.lambda_list_users.lambda_uri },
    "/user/update/{id}" = { method = "PUT",  lambda_uri = module.lambda_update_user.lambda_uri },
    "/user/delete"      = { method = "POST", lambda_uri = module.lambda_delete_user.lambda_uri },
    "/user/get-mfa"     = { method = "POST", lambda_uri = module.lambda_get_user_mfa.lambda_uri },
    "/user/add"         = { method = "POST", lambda_uri = module.lambda_add_user.lambda_uri },
    "/user/delete-mfa"  = { method = "POST", lambda_uri = module.lambda_delete_user_mfa.lambda_uri },
    "/user/get-user"    = { method = "POST", lambda_uri = module.lambda_get_user_by_id.lambda_uri },
    "/uservalidate"     = { method = "POST", lambda_uri = module.lambda_validate_user.lambda_uri },
    "/verify-mfa"       = { method = "POST", lambda_uri = module.lambda_verify_mfa.lambda_uri }
  }

  tags = {
    Project     = "Weconnect-Scheduler"
    Environment = "dev"
  }
}

output "api_url" {
  value       = module.api_gateway.api_url
  description = "API Gateway base URL"
}


module "scheduling_data_bucket" {
  source      = "../../modules/s3-backend"
  bucket_name = "weconnect-scheduling-data-test"
  tags = {
    Project     = "Weconnect-Scheduler"
    Environment = "dev"
  }
}


module "Scheduler_frontend_bucket" {
  source      = "../../modules/s3-backend"
  bucket_name = "www.dev.weconnect-scheduler.eastghats.com"
  tags = {
    Project     = "Weconnect-Scheduler"
    Environment = "dev"
  }
}
