export interface Asset {
    ID: string;
    color: string;
    size: number;
    owner: string;
    appraisedValue: number;
}

export interface History {
    record:    Asset;
    txId:      string;
    timestamp: string;
    isDelete:  boolean;
}