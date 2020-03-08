# frozen_string_literal: true

RSpec.describe Cheapseal::KubeDriver do
  let(:kube_driver) do
    Cheapseal::KubeDriver.new(src_namespace: 'src_ns', dst_namespace: 'new_ns', logger: Logger.new('/dev/null'))
  end

  describe '#create_namespace' do
    specify do
      expect(kube_driver).to receive(:kubectl).with(:create, :namespace, 'new_ns')
      kube_driver.create_namespace
    end
  end

  describe '#delete_namespace' do
    specify do
      expect(kube_driver).to receive(:kubectl).with(
        :delete, :namespace, 'new_ns', '--grace-period=0', '--force', raise_error: false
      )
      kube_driver.delete_namespace
    end
  end
end
