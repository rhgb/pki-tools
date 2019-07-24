#!/usr/bin/env node
const path = require('path');
let configPath = '../conf/pki.conf.json';
if (process.argv[2]) {
    configPath = path.join(process.cwd(), process.argv[2]);
}
const config = require(configPath);

function run() {
    console.log(`#!/bin/bash\nPATH=${__dirname}:$PATH`);
    console.log('\n# Prepare directories');
    console.log(`prepare_ca_dir.sh`);

    console.log('cd ca');
    console.log('\n# Generate Root CA');
    console.log(`gen_root_ca.sh "${config.commonSubject}" "${config.rootCommonName}"`);

    for (const authority of config.authorities) {
        console.log(`\n# Generate Intermediate CA ${authority.id}`);
        console.log(`gen_intermediate_ca.sh "${config.commonSubject}" "${authority.name}" ${authority.id}`);

        for (const identity of authority.identities) {
            console.log(`\n# Generate Certificate ${identity.id}`);
            console.log(`gen_cert.sh "${config.commonSubject}" ${identity.type} ${authority.id} "${identity.name}" ${identity.id}`);
        }
    }

    console.log(`cd ${process.cwd()}`);
}

run();