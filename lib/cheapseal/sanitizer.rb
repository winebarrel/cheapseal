# frozen_string_literal: true

module Cheapseal
  module Sanitizer
    MAX_KUEB_NS_LEN = 32

    class << self
      def branch_to_kube_ns(branch:, number:)
        # cf. https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
        sanitized_branch = branch.tr('/_.', '-').gsub(/-+/, '-').chomp('-')
        kube_ns = "#{sanitized_branch}-#{number}".downcase
        return kube_ns if kube_ns.length < MAX_KUEB_NS_LEN

        max_len = 32 - "-#{number}".length
        trimmed_branch = sanitized_branch.slice(0, max_len).chomp('-')
        "#{trimmed_branch}-#{number}".downcase
      end

      def underscore(str)
        str.tr('-', '_')
      end
    end
  end
end
