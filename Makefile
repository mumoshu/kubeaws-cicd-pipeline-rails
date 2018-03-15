.PHONY: test
test:
	sh -c 'ENV=test IMAGE=mumoshu/golang-k8s-aws:1.9.1 COMMAND="helmfile sync" SERVICE_ACCOUNT=default PROJECT=deis/empty-testbed helmfile sync'

.PHONY: binary
binary:
	ship/build/scripts/build

.PHONY: image
image:
	ship/build/scripts/dockerbuild

.PHONY: trigger-deploy
trigger-deploy:
	ship/release/scripts/trigger-deploy

.PHONY: deploy
deploy:
	ship/release/scripts/deploy

.PHONY: dockerpush
dockerpush:
	UPLOAD_ONLY=1 ship/build/scripts/dockerbuild

# https://www.phusionpassenger.com/library/config/standalone/intro.html#nginx-configuration-template
# https://www.phusionpassenger.com/library/config/standalone/reference/#--nginx-config-template-nginx_config_template
nginx.conf.erb:
	sh -c 'cp $(bundle exec passenger-config about resourcesdir)/templates/standalone/config.erb nginx.conf.erb'

.PHONY: baseimage-docker
baseimage-docker:
	sh -c 'cd baseimage-docker && env DISABLE_SSH=1 DISABLE_CRON=1 make build'
