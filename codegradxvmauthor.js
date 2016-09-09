#!/usr/bin/env node
/**

 Configure codegradxagent to use VMauthor

## Installation

```bash
npm install codegradxvmauthor
```

## Usage

This module configures the `codegradxagent` Node module to use the
VMauthor virtual machine rather than the real servers of the CodeGradX
infrastructure. It runs on Node.js. The VMauthor virtual machine is
available from http://www.paracamplus.com/VM/

The script `codegradxvmauthor` offers the same command line options
`codegradxagent` is offering plus one `--ip=` telling the host name or
the IP number of your running instance of the VMauthor virtual
machine.

@module codegradxvmauthor
@author Christian Queinnec <Christian.Queinnec@codegradx.org>
@license MIT
@see {@link http://codegradx.org/|CodeGradX} site.

 */

var CodeGradX = require('codegradxagent');
var _ = require('lodash');

// Exports what CodeGradX exports:
module.exports = CodeGradX;

/** Define VMauthorAgent to be a subclass of Agent adapted to VMauthor.
*/

CodeGradX.VMauthorAgent = function () {
    function initializer (agent) {
        // Add the --ip option:
        agent.configuration.push(['', 'ip=[IP]', 'VMauthor host name or IP']);
        return agent;
    }
    CodeGradX.Agent.call(this, initializer);
};
Object.setPrototypeOf(CodeGradX.VMauthorAgent.prototype, 
                      CodeGradX.Agent.prototype);    

// Default value for 'VMauthor', it may also be some IP.
CodeGradX.VMauthorAgent.vmhostname = 'vmauthor.codegradx.org';

/** Configure the servers to use.

    @returns {Agent}
*/

CodeGradX.VMauthorAgent.prototype.adaptToVMauthor = function () {
    var agent = this;
    var vmhostname = CodeGradX.VMauthorAgent.vmhostname;
    if ( agent.commands && 
         agent.commands.options.ip ) {
        vmhostname = agent.commands.options.ip;
    }
    agent.state.servers = {
        names: ['a', 'e', 'x', 's'],
        domain: vmhostname,
        a: {
            suffix: '/alive',
            0: {
                host: vmhostname + '/a'
            }
        },
        e: {
            suffix: '/alive',
            0: {
                host: vmhostname + '/e',
            }
        },
        x: {
            suffix: '/dbalive',
            0: {
                host: vmhostname + '/x',
            }
        },
        s: {
            suffix: '/index.html',
            0: {
                host: vmhostname + '/s',
            }
        }
    };
    return agent;
};

/** Parse options, adapt to VMauthor then run the agent.

    @param {Array<string>} strings.
    @returns {Promise<???>} depending on option `type`

*/

CodeGradX.VMauthorAgent.prototype.process = function (strings) {
    var agent = this;
    return agent.parseOptions(strings).adaptToVMauthor().run();
};

/* *********************************************************************
   Determine whether this module is used as a script or as a library.
   If used as a script then process the arguments otherwise do nothing.
*/

if ( _.endsWith(process.argv[1], 'codegradxvmauthor.js') ) {
    // We are running that script:
    var agent = new CodeGradX.VMauthorAgent();
    function failure (exc) {
        console.log('Failure: ' + exc);
        process.exit(1);
    }
    try {
        return agent.process(process.argv.slice(2))
            .then(function () { process.exit(0) })
            .catch(failure);
    } catch (exc) {
        failure(exc);
    };
}

// end of codegradxvmauthor.js
