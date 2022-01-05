import ballerina/log;

type WaitResult record {|
    boolean producer;
    boolean consumer;
|};

public function main() {
    log:printInfo("initializing app...");

    worker Producer returns boolean {
        int i = 100;
        i -> Consumer;
        log:printInfo("Sent item", i = i);
    }

    worker Consumer returns boolean {
        int i = <-Producer;
        log:printInfo("Received item", i=i);
    }

    WaitResult res = wait {};
    log:printInfo("Worker execution finished", result = res);
}
