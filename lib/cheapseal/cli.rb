# frozen_string_literal: true

module Cheapseal
  class CLI < Thor
    desc 'create BRANCH NUMBER', 'create kube staging'
    def create(branch, number)
      staging_creator = StagingCreator.new
      staging_creator.create(branch: branch, number: number)
    end
  end
end
