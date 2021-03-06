# encoding: utf-8
# Here we are putting the module name on the class, so the _type of the model
# can properly load. Works for querying through relations
Mongo::Logger.logger.level = Logger::INFO
module Mongoid

  # Instantiates documents that came from the database.
  module Factory
    extend self

    # Builds a new +Document+ from the supplied attributes.
    #
    # @example Build the document.
    #   Mongoid::Factory.build(Person, { "name" => "Durran" })
    #
    # @param [ Class ] klass The class to instantiate from if _type is not present.
    # @param [ Hash ] attributes The document attributes.
    # @param [ Hash ] options The mass assignment scoping options.
    #
    # @return [ Document ] The instantiated document.
    def build(klass, attributes = nil)
      # klass = "MongoModel::#{klass}"
      type = (attributes || {})[TYPE]
      if type && klass._types.include?(type)
        "MongoModel::#{type}".constantize.new(attributes)
      else
        klass.new(attributes)
      end
    end

    # Builds a new +Document+ from the supplied attributes loaded from the
    # database.
    #
    # @example Build the document.
    #   Mongoid::Factory.from_db(Person, { "name" => "Durran" })
    #
    # @param [ Class ] klass The class to instantiate from if _type is not present.
    # @param [ Hash ] attributes The document attributes.
    # @param [ Array ] selected_fields If instantiated from a criteria using
    #   #only we give the document a list of the selected fields.
    #
    # @return [ Document ] The instantiated document.
    def from_db(klass, attributes = nil, selected_fields = nil)
      type = (attributes || {})[TYPE]
      if type.blank?
        klass.instantiate(attributes, selected_fields)
      else
        "MongoModel::#{type}".camelize.constantize.instantiate(attributes, selected_fields)
      end
    end
  end
end
