# Emails

## Setup

Mails sent by the application are set up as follows:

* We used a [simple HTML email template](https://github.com/leemunroe/responsive-html-email-template) and changed this based on our needs.
* We moved the included CSS from this template to [app/assets/stylesheets/mailer.css.scss](../app/assets/stylesheets/mailer.css.scss) and used the [premailer-rails](https://github.com/fphilipe/premailer-rails) gem to convert it to inline CSS upon rendering.
* Development environment uses the [letter_opener](https://github.com/ryanb/letter_opener) gem to preview mails instead of sending.
* A preview of a mail (without the need to send one) is available in [http://localhost:3000/rails/mailers](http://localhost:3000/rails/mailers). See the [Rails guides](https://guides.rubyonrails.org/action_mailer_basics.html#previewing-emails) for more info on how to set this up.
* Mails sent by Devise are [configured such](../config/initializers/devise.rb#L298) that they use the [mailer layout file](../app/views/layouts/mailer.html.slim).

## Future improvements

The CSS file is a work in progress. When the design system is completed, we can use this knowledge to finalize the CSS. We then can decide to restructure the CSS by splitting up files, nest selectors, define (Sass) variables, etc.  
Importing [Tailwind CSS](https://tailwindcss.com/) (as we do for the end-user pages) seems not a good idea since this significantly increase the loading time of the email.

## Links

### Other online editors

* [https://topol.io](https://topol.io)
* [https://blocksedit.com](https://blocksedit.com)