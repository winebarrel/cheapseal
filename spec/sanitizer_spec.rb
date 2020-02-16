# frozen_string_literal: true

RSpec.describe Cheapseal::Sanitizer do
  describe '#branch_to_kube_ns' do
    context 'kube ns len <= max len' do
      specify do
        kube_ns = Cheapseal::Sanitizer.branch_to_kube_ns(branch: 'develop/my_branch-1.1', number: 123)
        expect(kube_ns).to eq('develop-my-branch-1-1-123')
      end
    end

    context 'kube ns len > max len' do
      specify do
        kube_ns = Cheapseal::Sanitizer.branch_to_kube_ns(
          branch: 'develop/my_branch-1.1/any-new-exciting-feature', number: 123
        )
        expect(kube_ns).to eq('develop-my-branch-1-1-any-ne-123')
      end
    end
  end

  describe '#underscore' do
    specify do
      underscored = Cheapseal::Sanitizer.underscore('develop-my-branch-1-1-any-ne-123')
      expect(underscored).to eq('develop_my_branch_1_1_any_ne_123')
    end
  end
end
