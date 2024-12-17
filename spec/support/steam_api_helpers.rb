# frozen_string_literal: true

# Module for seriliazing Rails models and factories to SteamAPI response
module SteamApiHelpers
  # Serialize Game achievements
  def api_achievemt_params(achievement)
    achievement = achievement.attributes unless achievement.is_a? Hash
    achievement = achievement.stringify_keys
    achievement.slice("description", "icon", "icongray").merge(
      "name" => achievement["uid"],
      "displayName" => achievement["name"],
      "hidden" => achievement["hidden"] ? 1 : 0,
    )
  end
end
