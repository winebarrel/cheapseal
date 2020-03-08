# frozen_string_literal: true

module Cheapseal
  class KubeDriver
    KUBECTL = 'kubectl'

    attr_reader :src_namespace
    attr_reader :dst_namespace

    def initialize(src_namespace:, dst_namespace:, logger:)
      @src_namespace = src_namespace
      @dst_namespace = dst_namespace
      @logger = logger
    end

    def create_namespace
      kubectl :create, :namespace, @dst_namespace
    end

    def delete_namespace
      kubectl :delete, :namespace, @dst_namespace, '--grace-period=0', '--force', raise_error: false
    end

    def namespace_exist?
      _out, _err, status = kubectl :get, :namespace, @dst_namespace, raise_error: false
      status.success?
    end

    def delete(resource:, name:)
      kubectl '-n', @dst_namespace, :delete, resource, name, raise_error: false
    end

    def copy(resource:, name:)
      out, _err, _status = kubectl '-n', @src_namespace, :get, resource, name, '-o', :json
      out = JSON.parse(out, symbolize_names: true)
      out.fetch(:metadata)[:namespace] = @dst_namespace
      out = yield(out) if block_given?
      kubectl :apply, '-f', '-', stdin_data: JSON.dump(out)
    end

    def copy_service(name:)
      copy(resource: :service, name: name) do |manifest|
        spec = manifest.fetch(:spec)
        spec.delete(:clusterIP)
        spec.fetch(:ports).fetch(0).delete(:nodePort)
        manifest
      end
    end

    def copy_ingress(name:, host:)
      copy(resource: :ingress, name: name) do |manifest|
        manifest.fetch(:spec).fetch(:rules).fetch(0)[:host] = host
      end
    end

    def configmap(name:, key:)
      out, _err, _status = kubectl :get, :configmap, name, '-o', :json
      out = JSON.parse(out, symbolize_names: true)
      out.fetch(:data).fetch(key)
    end

    def secret(name:, key:)
      out, _err, _status = kubectl :get, :secret, name, '-o', :json
      out = JSON.parse(out, symbolize_names: true)
      Base64.decode64(out.fetch(:data).fetch(key))
    end

    private

    def kubectl(*args, raise_error: true, stdin_data: nil)
      options = {}
      options[:stdin_data] = stdin_data
      cmd = [KUBECTL] + args.map(&:to_s)

      @logger.info("execute kubectl: #{cmd}")

      out, err, status = Open3.capture3(*cmd, options)
      unless raise_error && status.success?
        raise "kubectl failed (#{cmd}): status=#{status} stdout=#{out} stderr=#{err}"
      end

      @logger.info("kubectl executed: status=#{status} stdout=#{out} stderr=#{err}")

      [out, err, status]
    end
  end
end
