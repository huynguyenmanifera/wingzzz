User.destroy_all

User.create(
  [
    {
      email: 'andrew@infinitiux.com',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'jonny@kabisa.nl',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'lianne.van.thuijl@kabisa.nl',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'pascal@kabisa.nl',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'patrick@kabisa.nl',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'uj.adrien@gmail.com',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    },
    {
      email: 'luc.zwanenberg@kabisa.nl',
      password: 'P@ssw0rd1234',
      password_confirmation: 'P@ssw0rd1234',
      admin: true
    }
  ]
) { |u| u.confirmed_at = Time.now }
