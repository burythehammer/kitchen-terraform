# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'terraform/groups_coercer'
require 'support/raise_error_examples'
require 'support/terraform/configurable_context'

::RSpec.describe ::Terraform::GroupsCoercer do
  include_context 'instance'

  let(:described_instance) { described_class.new configurable: provisioner }

  describe '#coerce' do
    context 'when the value is a list of valid group mappings' do
      before do
        described_instance.coerce attr: :groups, value: [{ name: 'name' }]
      end

      subject { provisioner[:groups] }

      it 'coerces the value to groups' do
        is_expected.to contain_exactly instance_of ::Terraform::Group
      end
    end

    context 'when the value is a list of invalid group mappings' do
      it_behaves_like 'a user error has occurred' do
        let :described_method do
          described_instance.coerce attr: :groups, value: { name: 'name' }
        end

        let(:message) { /:groups.*a group mapping/ }
      end
    end

    context 'when the value is a list of unexpected elements' do
      it_behaves_like 'a user error has occurred' do
        let :described_method do
          described_instance.coerce attr: :groups, value: ''
        end

        let(:message) { /:groups.*a group mapping/ }
      end
    end
  end
end
