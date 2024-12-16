ActsAsTaggableOn::Tag.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      ['name']
    end

    def self.ransackable_associations(auth_object = nil)
      ['taggings']
    end
  end