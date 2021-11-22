const forever = Number.MAX_SAFE_INTEGER;
const never = Number.MIN_SAFE_INTEGER;

export interface Command {
  channel: string;
  visibleUntil: number;
}

export interface VisibilityState {
  commands: Command[];
}

export interface ShowConfig {
  channel?: string;
  ms?: number;
}

export interface HideConfig {
  channel?: string;
  delayMs?: number;
}

interface UIVisibilityProps {
  state: VisibilityState;
  currentTime: number;
}
export class UIVisibility {
  private props: UIVisibilityProps;

  constructor(props: UIVisibilityProps) {
    this.props = props;
  }

  static get initialState(): VisibilityState {
    return { commands: [] };
  }

  show(config?: ShowConfig): VisibilityState {
    const visibleUntil = (() => {
      return config?.ms ? this.props.currentTime + config.ms : forever;
    })();

    const channel = config?.channel ? config.channel : "_global";

    return this.updateOrAddCommand({
      channel,
      visibleUntil,
    });
  }

  hide(config?: HideConfig) {
    const channel = config?.channel ? config.channel : "_global";
    const visibleUntil = config?.delayMs
      ? this.props.currentTime + config.delayMs
      : never;

    if (this.channelExists(channel) && this.channelIsVisible(channel)) {
      return this.updateExistingChannel({
        channel,
        visibleUntil,
      });
    } else {
      return this.props.state;
    }
  }

  get isVisible() {
    const visibleUntil = this.props.state.commands.reduce(
      (candidate, command) => {
        return command.visibleUntil > candidate
          ? command.visibleUntil
          : candidate;
      },
      never
    );

    return this.props.currentTime <= visibleUntil;
  }

  get nextVisibilityChange() {
    const latestVisibleUntil = this.props.state.commands.reduce(
      (candidate, command) => {
        return command.visibleUntil > candidate
          ? command.visibleUntil
          : candidate;
      },
      never
    );

    return latestVisibleUntil !== forever &&
      latestVisibleUntil > this.props.currentTime
      ? latestVisibleUntil - this.props.currentTime
      : null;
  }

  private updateOrAddCommand(newCommand: Command) {
    if (this.channelExists(newCommand.channel)) {
      return {
        commands: this.props.state.commands.map((command) => {
          return newCommand.channel === command.channel ? newCommand : command;
        }),
      };
    } else {
      return {
        commands: this.props.state.commands.concat(newCommand),
      };
    }
  }

  private channelExists(channel: string) {
    return !!this.findCommandByChannel(channel);
  }

  private findCommandByChannel = (channel: string) => {
    return this.props.state.commands.find((c) => c.channel === channel);
  };

  private channelIsVisible(channel: string) {
    const command = this.findCommandByChannel(channel);
    if (command) {
      return command.visibleUntil >= this.props.currentTime;
    } else {
      return false;
    }
  }

  private updateExistingChannel(newCommand: Command) {
    return {
      commands: this.props.state.commands.map((command) => {
        return newCommand.channel === command.channel ? newCommand : command;
      }),
    };
  }
}
