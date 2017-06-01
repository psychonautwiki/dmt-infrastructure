var countlyConfig = {
    mongodb: {
        host: "mongo",
        db: "countly",
        port: 27017,
        max_pool_size: 20,
        dbOptions:{
            //db options
            native_parser: true
        },
        serverOptions:{
            //server options
            ssl:false
        }
    },
    web: {
        port: 6001,
        host: "0.0.0.0",
        use_intercom: true
    },
    path: "",
    cdn: ""
};

module.exports = countlyConfig;
