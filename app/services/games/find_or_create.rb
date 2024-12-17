# frozen_string_literal: true

class Games::FindOrCreate
  include Callable
  include Dry::Monads[:result, :do]

  attr_reader :user, :form

  def initialize(user, form)
    @user = user
    @form = form
  end

  def call
    yield validate_form
    yield find_game_info
    yield assign_game_params
    yield find_achievements_info
    update_game
  end

  private

  delegate :app_uid, to: :form

  def validate_form
    form.valid? ? Success() : Failure(form.errors.full_messages.first)
  end

  def find_game_info
    game_info.present? || game.persisted? ? Success() : Failure(I18n.t("games.find_or_create.no_found_error"))
  end

  def find_achievements_info
    achievements_info.nil? ? Failure(I18n.t("games.find_or_create.no_found_error")) : Success()
  end

  def update_game
    game.transaction do
      game.save!

      achievements_info.each do |info|
        existed_achievements.exclude?(info["name"]) && Achievements::Create.call(game, info)
      end
    end

    Success(game.reload)
  end

  def assign_game_params
    game.assign_attributes(game_params) if game_info.present?

    if game.valid?
      Success()
    else
      Failure(I18n.t("games.find_or_create.no_all_params"))
    end
  end

  def game_params
    {
      name: game_info["name"],
      image: game_info["header_image"],
    }
  end

  def game
    @_game ||= Game.find_or_initialize_by(app_uid:)
  end

  def existed_achievements
    @_existed_achievements ||= game.achievements.to_set(&:uid)
  end

  def achievements_info
    @_achievements_info ||= api_steam_client.achievements_info(app_uid) || []
  end

  def game_info
    @_game_info ||= steam_store_client.game_info(app_uid)
  end

  def api_steam_client
    @_api_steam_client ||= Steam::ApiClient.new(user)
  end

  def steam_store_client
    @_steam_store_client ||= Steam::StoreClient.new
  end
end
