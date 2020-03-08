# frozen_string_literal: true

module Cheapseal
  class CLI < Thor
    LOGGER = Logger.new($stdout)

    desc 'create SRC_NAMESPACES BRANCH NUMBER IMAGE', 'Create kube staging'
    option :src, type: :string, required: true
    option :branch, type: :string, required: true
    option :number, type: :numeric, required: true
    option :image, type: :string, required: true
    option :service, type: :array, required: true
    option :copy, type: :array, required: true
    def create
      staging = Staging.new(
        src_namespace: options[:src],
        dst_namespace: dst_namespace(branch: options[:branch], number: options[:number]),
        logger: LOGGER
      )

      staging.create(image: options[:image], service: options[:service], copy: options[:copy])
    end

    desc 'delete SRC_NAMESPACES BRANCH NUMBER', 'Delete kube staging'
    option :src, type: :string, required: true
    option :branch, type: :string, required: true
    option :number, type: :string, required: true
    def delete
      staging = Staging.new(
        src_namespace: options[:src],
        dst_namespace: dst_namespace(branch: options[:branch], number: options[:number]),
        logger: LOGGER
      )

      staging.delete
    end

    desc 'namespace', 'Build kube namespace'
    option :branch, type: :string, required: true
    option :number, type: :string, required: true
    def namespace
      $stdout.puts dst_namespace(branch: options[:branch], number: options[:number])
    end

    private

    def dst_namespace(branch:, number:)
      Sanitizer.branch_to_kube_ns(branch: branch, number: number)
    end
  end
end
