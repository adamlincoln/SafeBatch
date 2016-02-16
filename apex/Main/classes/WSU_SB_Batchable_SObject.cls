// This file is part of SafeBatch, a Limit avoidance utility for Batch Apex on the Force.com platform.
//
// Copyright 2013-2014, Wayne State University
// License: 3-clause BSD license.  See LICENSE.

public virtual class WSU_SB_Batchable_SObject extends WSU_SB_Batchable {
    @TestVisible
    protected List<sObject> sobjsSkipped;

    protected override void init() {
        if (initRun == null || !initRun) {
            sobjsSkipped = new List<sObject>();
            initRun = true;
        }
        super.init();
    }

    public WSU_SB_Batchable_SObject(String implementationName, Map<String, Object> implementationArgs, Map<String, Object> options) {
        super(implementationName, implementationArgs, options);
    }

    public WSU_SB_Batchable_SObject() {
        super();
    }

    public override void setImplementation() {
        if (implementationType != null && this.implementation == null) { // We might run this method more than once because it gets called from init()
            if (implementationType.newInstance() instanceof WSU_SB_Interface_SObject) {
                if (implementationArgs == null) {
                    this.implementation = (WSU_SB_Interface_SObject)implementationType.newInstance();
                } else {
                    this.implementation = (WSU_SB_Interface_SObject)JSON.deserialize(JSON.serialize(implementationArgs), implementationType);
                }
            } else {
                throw new SB_BatchableException('Implementation is not of type WSU_SB_Interface_SObject.');
            }
        }
    }

    protected override String limitCheck() {
        reserved = implementation.reserve();
        return super.limitCheck();
    }

}
