const EventEmitter = require("events");
const uuid = require("uuid");

class Job extends EventEmitter {
  constructor() {
    super();
    this.id = uuid.v1();
  }
}

let jobs = {};

module.exports.create = function () {
  const job = new Job();
  jobs[job.id] = job;

  return job;
};

module.exports.get = function (id) {
  return jobs[id];
};

module.exports.delete = function (job) {
  job.removeAllListeners();
  delete jobs[job.id];
};
