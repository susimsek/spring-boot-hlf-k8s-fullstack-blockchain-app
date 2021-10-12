import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {MatToolbarModule} from '@angular/material/toolbar'; 
import {MatIconModule} from '@angular/material/icon'; 
import {  MatSidenavModule,  } from  '@angular/material/sidenav';
import { MatListModule,   } from "@angular/material/list";
import { MatButtonModule } from "@angular/material/button";
import { AssetListComponent } from './asset-list/asset-list.component';
import {MatTableModule} from '@angular/material/table';
import { MatTooltipModule } from '@angular/material/tooltip';
import { MatFormFieldModule } from '@angular/material/form-field';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {  MatInputModule} from "@angular/material/input";
import {MatCardModule} from '@angular/material/card';
import { AssetDialogComponent } from './asset-dialog/asset-dialog.component';
import { MatDialogModule } from '@angular/material/dialog';
import { HistoryDialogComponent } from './history-dialog/history-dialog.component';
@NgModule({
  declarations: [
    AppComponent,
    AssetListComponent,
    AssetDialogComponent,
    HistoryDialogComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    BrowserAnimationsModule,
    MatToolbarModule,
    MatIconModule,
    MatToolbarModule,
    MatSidenavModule,
    MatListModule,
    MatButtonModule,
    MatIconModule,
    MatTableModule,
    MatTooltipModule,
    MatFormFieldModule,
    ReactiveFormsModule,
    FormsModule,
    MatFormFieldModule,
    MatInputModule,
    MatCardModule,
    MatDialogModule
  ],
  providers: [],
  bootstrap: [AppComponent],
  entryComponents:[AssetDialogComponent,HistoryDialogComponent]
})
export class AppModule { }
