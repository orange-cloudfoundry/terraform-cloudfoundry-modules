# terraform-cloudfoundry-modules

This repo is a set of useful [terraform modules](https://www.terraform.io/docs/modules/index.html) to make some tasks painless.
This also show what you can do with [terraform-provider-cloudfoundry](https://github.com/orange-cloudfoundry/terraform-provider-cloudfoundry) to create powerful module for powerful deployment/configuration.

For now, 2 modules has been created:

- [deploy-app](/deploy-app): Deploy an application as you could do it with a cloud foundry manifest with some enhancements (with blue-green restage/deploy from [apps resource](https://github.com/orange-cloudfoundry/terraform-provider-cloudfoundry#applications))
- [deploy-service-broker](/deploy-service-broker): Deploy a cloud foundry app and set it as a service broker

## Usage

You can use those modules by simply copy folder or embed this repo as a git submodule in your configuration.

## deploy-app

```tf
provider "cloudfoundry" {
  api_endpoint = "https://api.my.cloudfoundry.com"
  username = "user"
  password = "password"
}
module "deploy_myapp" {
  source = "path/to/module/deploy-app"
  name = "myapp"
  org = "system_domain"
  space = "a-space"
  path = "/path/to/the/code/or/url"
  buildpack = ""
  command = ""
  disk_quota = "1G"
  memory = "512M"
  health_check_http_endpoint = ""
  health_check_type = ""
  health_check_timeout = ""
  instances = 1
  diego = true
  started = true
  enable_ssh = false
  stack = "cflinuxfs2"
  domains = ["shared.domain.com", "private.domain.com"]
  services = [{
      name = "my-mysql"
      service = "p-mysql"
      plan = "10mb"
    }]
  route_services = [{
      name = "my-route-service"
      service = "route-service"
      plan = "a-plan"
    }]
  host = "myapp"
  ports = [8080]
  env_var = {
    "env1" = "value1"
    "env2" = "value2"
  }
}
```

- **name**: (**Required**) Name of your application.
- **org**: (**Required**) Name of your organization.
- **space**: (**Required**) Name of your space inside the organization.
- **path**: (**Required**) Path to a folder which contains application code, url to a zip/jar, url to a tgz/tar or a git url following the scheme: https://[user:password@]mygit.com/myrepo.git[#tag-or-branch-or-commit-hash]
- **buildpack**: *(Optional, default: `NULL`)* Buildpack to build the app. 3 options: a) Blank means autodetection; b) A Git Url pointing to a buildpack; c) Name of an installed buildpack.
- **command**: *(Optional, default: `NULL`)* The command to start an app after it is staged.
- **disk_quota**: *(Optional, default: `1G`)* The maximum amount of disk available to an instance of an app.
- **domains**: *(Optional, default: `first shared domain found`)* use this parameters to provide multiple domains, this will create multiple routes created to your app.
- **health_check_http_endpoint**: *(Optional, default: `NULL`)* Endpoint called to determine if the app is healthy. (Can  be use only when check type is http)
- **health_check_type**: *(Optional, default: `port`)* Type of health check to perform. Others values are: 
  - http (Diego only)
  - port
  - process
  - none
- **health_check_timeout**: *(Optional, default: 0)* Timeout in seconds for health checking of an staged app when starting up.
- **host**: *(Optional, default: `app name`)* Use this parameter to provide a hostname.
- **instances**: *(Optional, default: `1`)* The number of instances of the app to run.
- **memory**: *(Optional, default: `512M`)* The amount of memory each instance should have.
- **diego**: *(Optional, default: `true`)* Use diego to stage and to run when available (Diego should be always available because DEA is not supported anymore).
- **started**: *(Optional, default: `true`)* when set to false app will not be started.
- **enable_ssh**: *(Optional, default: `false`)* Enable SSHing into the app. Supported for Diego only.
- **stack**: *(Optional, default: `first stack found`)* Name of the stack to use.
- **env_var**: *(Optional, default: `NULL`)* Add any variable you want to the app environment.
- **ports**: *(Optional, default: `8080` when diego is set to `true`)* List of ports on which application may listen. Overwrites previously configured ports. 
- **services**: List of services to use to bind to your app, they will be created if they don't exists. Parameters to use:
  - **name**: (**Required**) Name of your service.
  - **user_provided**: *(Optional, default: `false`)* Set to `true` to create an user provided service. **Note**: `service` and `plan` params will not be used.
  - **params**: *(Optional, default: `null`)* Must be json, if it's an user provided service it will be credential for your service instead it will be params sent to service broker when creating service.
  - **update_params**: *(Optional, default: `null`)* Must be json, Params sent to service broker when updating service.
  - **tags**: *(Optional, default: `null`)* list of tags for your service.
  - **service**: (**Required when not user provided service**) name of service from marketplace.
  - **plan**: (**Required when not user provided service**) name of the plan to use.
  - **route_service_url**: *(Optional, default: `null`)* Only works for user provided, an url to create a [route service](https://docs.cloudfoundry.org/services/route-services.html)
  - **syslog_drain_url**: *(Optional, default: `null`)* Only works for user provided, an url to drain logs as a service on an app.
- **route_services**:  List of route services to use to bind to your route(s), they will be created if they don't exists. First route service will be bind to first route, the second to the second route ... Parameters to use are the same as **services**.
- **path_for_route**: *(Optional, default: `null`)* Set a path for your route (only works with a http(s) domain).
- **port_for_route**: *(Optional, default: `-1`)* Set a port for your route (only works with a tcp domain). **Note**: If `0` a random port will be chose.


**Note**: This module will give as output the app uri(s) as variable `app_uris`.

## deploy-service-broker

```tf
provider "cloudfoundry" {
  api_endpoint = "https://api.my.cloudfoundry.com"
  username = "user"
  password = "password"
}
module "deploy_myservicebroker" {
  source = "path/to/module/deploy-service-broker"
  name = "myservicebroker"
  org = "system_domain"
  space = "a-space"
  path = "/path/to/the/code/of/my/app/or/zip/url"
  buildpack = ""
  command = ""
  disk_quota = "1G"
  memory = "512M"
  health_check_http_endpoint = ""
  health_check_type = ""
  health_check_timeout = ""
  instances = 1
  diego = true
  started = true
  enable_ssh = false
  stack = "cflinuxfs2"
  domains = ["shared.domain.com", "private.domain.com"]
  services = [{
      name = "my-mysql"
      service = "p-mysql"
      plan = "10mb"
    }]
  route_services = [{
      name = "my-route-service"
      service = "route-service"
      plan = "a-plan"
    }]
  host = "myapp"
  ports = [8080]
  env_var = {
    "env1" = "value1"
    "env2" = "value2"
  }
  broker_name = "superservicebroker"
  broker_username = "fakeuser"
  broker_password = "fakepassword"
  space_scoped = false
  service_access = [{
    service = "fake-service"
  }]
}
```

Parameters `broker_name`, `broker_username`, `broker_password`, `space_scoped` and `service_access` are the only paremeters which are different from [deploy-app](#deploy-app) module.

- **broker_name**: *(Optional, default: `app name`)* Name of your service broker.
- **broker_username**: *(Optional, default: `null`)* Username to authenticate to your service broker.
- **broker_password**: *(Optional, default: `null`)* Password to authenticate to your service broker. **Note**: you can pass a base 64 encrypted gpg message if you [enabled password encryption](https://github.com/orange-cloudfoundry/terraform-provider-cloudfoundry#enable-password-encryption).
- **space_scoped**: *(Optional, default: `false`)* if set to `true` the service broker will be created as a space-scoped service broker set on space asked. 
- **service_access**: (**Required if space_scoped is false**) Add service access as many as you need, service access make you service broker accessible on marketplace:
  - **service**: (**Required**) Service name from your service broker catalog to activate. **Note**: if there is only service in your service access it will enable all plan on all orgs on your Cloud Foundry.
  - **plan**: *(Optional, default: `null`)* Plan from your service broker catalog attached to this service to activate. **Note**: if no `org_id` is given it will enable this plan on all orgs.
  - **org_id**: *(Optional, default: `null`)* Org id created from resource or data source [cloudfoundry_organization](#organizations) to activate this service. **Note**: if no `plan` is given it will all plans on this org.