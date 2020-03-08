# frozen_string_literal: true

module Cheapseal
  class CLI < Thor
    desc 'create BRANCH NUMBER IMAGE', 'create kube staging'
    def create(branch, number, image)
      staging_creator = StagingCreator.new
      staging_creator.create(branch: branch, number: number, image: image)
    end
  end
end
