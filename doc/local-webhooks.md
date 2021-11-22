# Testing (Mollie) webhooks locally

In order to test payment functionality locally you need to (temporarily) expose your local development server
on the internet. It's recommended to use [Inlets](https://inlets.dev) for this. If you have an Heroku account it's
pretty straightfoward to setup using [these instructions](https://github.com/pascalw/inlets-heroku). In short:

1. Deploy a personal Inlets instance to Heroku.
2. Connect your Inlets instance to your local Rails server using the provided `inlets-client.sh` script:
   ```sh
   ./inlets-client.sh http://localhost:3000
   ```
3. Configure your local Wingzzz instance to use Inlets as an exit node:
   ```sh
   echo 'EXIT_NODE_HOST=<your heroku inlets host>.herokuapp.com' >> .env
   ```
4. Restart your Rails server.
5. If you make a Mollie payment now, Mollie will notify your local server of the payment status.

When you're done testing (Mollie) webhooks, shutdown the Inlets client using `Ctrl-c`.
