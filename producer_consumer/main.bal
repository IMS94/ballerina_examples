import ballerina/log;

type WaitResult record {|
    boolean producer;
    boolean consumer;
|};

public function main() {
    log:printInfo("initializing app...");

    // Producer 1
    worker Producer1 returns boolean {
        int i = 100;
        i -> Consumer;
        log:printInfo("Sent item", i = i);
        return true;
    }

    worker Producer2 returns boolean {
        int i = 100;
        i -> Consumer;
        log:printInfo("Sent item", i = i);
        return true;
    }

    // Consumer
    worker Consumer returns boolean {
        int i = <- Producer1;
        log:printInfo("Received item", i = i);
        i = <- Producer2;
        log:printInfo("Received item", i = i);
        return false;
    }

    WaitResult res = wait {producer: Producer1, consumer: Consumer};
    log:printInfo("Worker execution finished", result = res);
}
