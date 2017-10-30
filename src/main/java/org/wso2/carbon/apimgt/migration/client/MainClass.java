package org.wso2.carbon.apimgt.migration.client;

/**
 * Created by ramindu on 10/27/17.
 */
public class MainClass {
    public static void main(String[] args) {
        String apiFilePath = args[0];
//        String apiFilePath = "/Users/ramindu/Downloads/synapse-configsNew/default/api";
        MigrateFrom18to19.synapseAPIMigration17_19(apiFilePath);
        MigrateFrom19to110.synapseAPIMigration19_110(apiFilePath);
        MigrateFrom110to200.synapseAPIMigration110_200(apiFilePath);
    }
}
