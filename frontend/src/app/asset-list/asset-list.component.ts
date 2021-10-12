import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AssetDialogComponent } from '../asset-dialog/asset-dialog.component';
import { Asset } from '../asset.model';
import { HistoryDialogComponent } from '../history-dialog/history-dialog.component';
import { HttpService } from '../services/http.service';

@Component({
  selector: 'app-asset-list',
  templateUrl: './asset-list.component.html',
  styleUrls: ['./asset-list.component.css']
})
export class AssetListComponent implements OnInit {
  assets: Asset[] = []
  displayedColumns: string[] = ['sno', 'id', 'owner', 'size', 'color', 'appraisedValue', 'actions'];
  dataSource;
  ngOnInit(): void {
this.getAssets();

  }
  constructor(private httpService: HttpService, private dialog: MatDialog) { }
  title = 'ui';


  getAssets() {
    this.httpService.getAssets().subscribe((response:any)=>{
      let data=response;
      this.assets= data.map(item=>item.Record)
      this.dataSource = this.assets;
    });
  }

  createDialog() {
    const dialogRef = this.dialog.open(AssetDialogComponent, {
      width: '400px',
      data: {asset:null,button:"Create Asset"}
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        console.log(result)
        this.httpService.createAsset(result).subscribe(data=>{
          console.log(data);
          this.getAssets();
        })
      }
    });
  }


  updateAsset(id: string,asset: Asset) {
    const dialogRef = this.dialog.open(AssetDialogComponent, {
      width: '400px',
      data: {asset:asset,button:"Update Asset"}
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.httpService.updateAsset(id,result).subscribe(data=>{
          this.getAssets()
        });
      }
    });
  }
  deleteAsset(id: string) {
    console.log(id)
    if(confirm("Are you sure you want to delete?"))
    this.httpService.deleteAsset(id).subscribe(data=>{
      this.getAssets()
    });
  }

  history(id:string){


   this.httpService.getHistory(id).subscribe(data=>{
console.log(data);
     this.dialog.open(HistoryDialogComponent, {
      width: '500px',
      data
    });
   });


  }
}
