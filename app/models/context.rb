class Context < ActiveRecord::Base
    belongs_to :user
    has_and_belongs_to_many :notes

    attr_accessible :name, :active
end
