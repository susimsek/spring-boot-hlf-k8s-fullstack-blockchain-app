import { Component, Inject, OnInit } from '@angular/core';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Asset } from '../asset.model';
@Component({
  selector: 'app-asset-dialog',
  templateUrl: './asset-dialog.component.html',
  styleUrls: ['./asset-dialog.component.css']
})
export class AssetDialogComponent implements OnInit {
  assetForm: FormGroup;
  constructor(public dialogRef: MatDialogRef<AssetDialogComponent>,
    private formBuilder: FormBuilder,
    @Inject(MAT_DIALOG_DATA) public data: any) {
    this.assetForm = this.formBuilder.group({
      "ID": [null, Validators.required],
      "owner": [null, Validators.required],
      "color": [null, Validators.required],
      "size": [null, Validators.required],
      "appraisedValue": [null, Validators.required]
    });
    if (data.asset){
      this.assetForm.setValue(data.asset);
      this.assetForm.controls['ID'].disable();
    }
  }

  ngOnInit(): void {
  }

  submit() {
    this.dialogRef.close(Object.assign(this.assetForm.getRawValue() as Asset));

  }
}
