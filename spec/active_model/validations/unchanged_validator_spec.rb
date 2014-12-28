require 'spec_helper'

describe ActiveModel::Validations::UnchangedValidator do
  describe '#validate_each' do
    let(:record) { double('Model') }
    let(:record_is_new) { false }
    let(:record_attribute) { :attribute }
    let(:record_attribute_has_changed) { false }
    let(:record_errors) { double('errors') }
    let(:options) { { attributes: record_attribute, a: 1, b: 2} }
    let(:validator) { ActiveModel::Validations::UnchangedValidator.new(options) }
    let(:value) { 'something' }

    before do
      allow(record).to receive(:new_record?).and_return(record_is_new)
      allow(record).to receive(:"#{record_attribute}_changed?").and_return(record_attribute_has_changed)
      allow(record).to receive(:errors).and_return(record_errors)
      allow(record_errors).to receive(:add).with(record_attribute, :changed, options.reject { |k| k == :attributes} )
    end

    context 'when the record is' do
      context 'new' do
        let(:record_is_new) { true }

        it 'does not add an error' do
          validator.validate_each(record, record_attribute, value)
          expect(record_errors).not_to have_received(:add)
        end
      end

      context 'not new' do
        let(:record_is_new) { false }

        context 'and the attribute has' do
          context 'changed' do
            let(:record_attribute_has_changed) { true }

            it 'adds and error' do
              validator.validate_each(record, record_attribute, value)
              expect(record_errors).to have_received(:add)
            end
          end

          context 'not changed' do
            let(:record_attribute_has_changed) { false }

            it 'adds and error' do
              validator.validate_each(record, record_attribute, value)
              expect(record_errors).not_to have_received(:add)
            end
          end
        end
      end
    end
  end
end
