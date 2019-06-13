# frozen_string_literal: true

class State
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
end
