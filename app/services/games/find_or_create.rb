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
    yield update_game_params
    game.reload
    Success(game)
  end

  private

  delegate :app_uid, to: :form

  def validate_form
    form.valid? ? Success() : Failure(form.errors.full_messages.first)
  end

  def find_game_info
    game_info.present? || game.persisted? ? Success() : Failure(I18n.t("games.find_or_create.no_found_error"))
  end

  def update_game_params
    if game_info.present?
      game.assign_attributes(
        name: game_info["name"],
        image: game_info["header_image"]
      )

      game.save if game.valid?
    end

    if game.persisted?
      Success()
    else
      Failure(I18n.t("games.find_or_create.no_all_params"))
    end
  end

  def game
    @_game ||= Game.find_or_initialize_by(app_uid: app_uid)
  end

  def game_info
    @_game_info ||= steam_store_client.game_info(app_uid)
  end

  def steam_store_client
    @_steam_store_client ||= Steam::StoreClient.new
  end
end
