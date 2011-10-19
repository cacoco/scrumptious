require 'active_support/inflector'

ActiveSupport::Inflector::Inflections.instance.instance_eval do
  def past_tenses
    @past_tenses
  end

  def past_tense(rule, replacement)
    @past_tenses = [] if !@past_tenses
    @uncountables.delete(rule) if rule.is_a?(String)
    @uncountables.delete(replacement)
    @past_tenses.insert(0, [rule, replacement])
  end
end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.past_tense /^(.*)$/,'\1ed'
  inflect.past_tense /e$/,'ed'
  inflect.past_tense /t$/,'ted'
  inflect.past_tense /g$/,'gged'
  inflect.past_tense /ight$/,'ought'
  inflect.past_tense "buy",'bought'
  inflect.past_tense "sell",'sold'
  inflect.past_tense "is",'was'
  inflect.past_tense "are",'were'
  inflect.past_tense "teach",'taught'
  inflect.past_tense "feel",'felt'
  inflect.past_tense "light",'lit'
  inflect.past_tense "find",'found'
end

module Inflectionist
  def self.past_tensed(word)
    result = word.to_s.dup
    if word.empty? || ActiveSupport::Inflector.inflections.uncountables.include?(result.downcase)
      result
    else
      ActiveSupport::Inflector.inflections.past_tenses.each do |(rule, replacement)| 
        break if result.gsub!(rule, replacement)
      end
      result
    end
  end
end