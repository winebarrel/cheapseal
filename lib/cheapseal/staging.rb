# frozen_string_literal: true

module Cheapseal
  class Staging
    def initialize(src_namespace:, dst_namespace:, logger:)
      @logger = logger
      @kube_driver = KubeDriver.new(src_namespace: src_namespace, dst_namespace: dst_namespace, logger: logger)
    end

    def create(image:, service:, copy:)
      @logger.warn("Staging namespace already exists: #{@kube_driver.dst_namespace}") if @kube_driver.namespace_exist?

      @logger.info("Create staging namespace: #{@kube_driver.dst_namespace}")
      @kube_driver.create_namespace

      copy.each do |rn|
        @logger.info("Copy kube resource: #{rn}}")

        rn = rn.split('/', 2)
        resource = rn.fetch(0)
        name = rn.fetch(1)
        @kube_driver.copy(resource: resource, name: name)
      end

      # XXX:
      puts image
      puts service
      true
    end

    def delete; end
  end
end
