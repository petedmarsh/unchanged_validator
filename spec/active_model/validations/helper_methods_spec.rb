require 'spec_helper'

describe ActiveModel::Validations::HelperMethods do
  class Person
    include ActiveModel::Dirty
    include ActiveModel::Validations

    define_attribute_methods [:name]

    def initialize
      @name = nil
      @new_record = true
    end

    def name
      @name
    end

    def name=(val)
      name_will_change! unless val == @name
      @name = val
    end

    def save
      changes_applied
      @new_record = false
    end

    def reload
      clear_changes_information
    end

    def deprecated_reload
      reset_changes
    end

    def new_record?
      @new_record
    end

    def changes_applied
      @previously_changed = changes
      @changed_attributes = ActiveSupport::HashWithIndifferentAccess.new
    end
  end

  describe '.validates_unchanged' do
    let(:attribute) { :name }
    let(:options) { {} }
    let(:previous_value) { 'Dave' }
    let(:new_value) { 'Bob' }

    before do
      Person.reset_callbacks(:validate)
      Person.validates_unchanged(attribute, options)
    end

    context 'when the record is' do
      context 'new' do
        let(:record) { Person.new }

        context 'and the attribute has' do
          context 'been set' do

            it 'does not add an error' do
              record.name = new_value
              expect(record).to be_valid
            end
          end

          context 'not been set' do

            it 'does not add an error' do
              expect(record).to be_valid
            end
          end
        end

        context 'not new' do
          let(:record) do
            p = Person.new
            p.name = previous_value
            p.save
            p
          end

          context 'and the attribute has' do
            context 'been set to' do
              context 'the same value' do

                it 'does not add an error' do
                  record.name = record.name
                  expect(record).to be_valid
                end
              end

              context 'a different value' do

                it 'adds an error' do
                  record.name = new_value
                  expect(record).not_to be_valid
                  expect(record.errors[:name]).to eq ['must not change']
                end
              end
            end

            context 'when the option' do
              context 'allow_blank is true' do
                let(:options) { { allow_blank: true } }

                context 'and the attribute was not blank and the new value is blank' do
                  let(:new_value) { '' }

                  it 'does not add an error' do
                    record.name = new_value
                    expect(record).to be_valid
                  end
                end
              end

              context 'allow_nil is true' do
                let(:options) { { allow_nil: true } }

                context 'and the attribute was not nil and the new value is nil' do
                  let(:new_value) { nil }

                  it 'does not add an error' do
                    record.name = new_value
                    expect(record).to be_valid
                  end
                end
              end
            end

            context 'message has been specified' do
              let(:message) { 'should not change' }
              let(:options) { { message: message } }

              context 'when an error is added' do
                it 'gives specified message' do
                  record.name = new_value
                  expect(record).not_to be_valid
                  expect(record.errors[:name]).to eq [message]
                end
              end
            end
          end
        end
      end
    end
  end
end