module SectionedForm
  class MandateDetailsComponent < ViewComponent::Base
    # A Mollie mandate can have one of 3 methods,
    # see https://docs.mollie.com/reference/v2/mandates-api/get-mandate
    # PAYMENT_METHODS defines for each method which attributes
    # should be presented and which icons to show.
    DIRECTCREDIT = {
      attributes: %i[consumer_name consumer_account], icons: %i[ideal]
    }.freeze
    CREDITCARD = {
      attributes: %i[card_number card_holder card_expiry_date],
      icons: %i[mastercard visa amex]
    }.freeze
    PAYPAL = {
      attributes: %i[consumer_name consumer_account], icons: %i[paypal]
    }.freeze
    PAYMENT_METHODS = {
      directdebit: DIRECTCREDIT, creditcard: CREDITCARD, paypal: PAYPAL
    }.with_indifferent_access

    attr_reader :mandate

    delegate :consumer_name, :card_holder, to: :mandate_details

    def initialize(mandate:)
      @mandate = mandate
    end

    def payment_images_and_words
      safe_join([payment_method_words, payment_method_images], ' ')
    end

    # @example
    # subsription.consumer_account
    # # => 'NL55 INGB 0000 0000 00'
    def consumer_account
      mandate_details.consumer_account.scan(/.{1,4}/m).join(' ')
    end

    def card_number
      "**** **** **** #{mandate_details.card_number}"
    end

    def card_expiry_date
      I18n.l(mandate_details.card_expiry_date.to_date, format: :long)
    end

    def attributes
      PAYMENT_METHODS.dig(payment_method, :attributes)
    end

    private

    def payment_method_words
      I18n.t(payment_method)
    end

    def payment_method_images
      safe_join(
        icons.map do |icon|
          inline_svg_tag "icons/payment-methods/#{icon}.svg",
                         class: 'inline-block'
        end,
        ' '
      )
    end

    def payment_method
      mandate.method
    end

    def mandate_details
      mandate.details
    end

    def icons
      PAYMENT_METHODS.dig(payment_method, :icons)
    end
  end
end
