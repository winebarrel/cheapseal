# frozen_string_literal: true

module Cheapseal
  class CLI < Thor
    desc 'create BRANCH NUMBER IMAGE', 'Create kube staging'
    def create(branch, number, image)
      staging = Staging.new
      staging.create(branch: branch, number: number, image: image)
    end

    desc 'delete BRANCH NUMBER', 'Delete kube staging'
    def delete(branch, number)
      staging = Staging.new
      staging.delete(branch: branch, number: number)
    end
  end
end
