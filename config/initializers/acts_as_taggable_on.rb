ActsAsTaggableOn::Tag.class_eval do
  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(_auth_object = nil)
    ['taggings']
  end
end
