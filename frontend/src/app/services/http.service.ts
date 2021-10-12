import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from "rxjs";
import { environment } from 'src/environments/environment';
import { Asset, History } from '../asset.model';

@Injectable({
  providedIn: 'root'
})
export class HttpService {

  constructor(private http: HttpClient) { }

  getAssets() {
    return this.http.get(`${environment.baseUrl}/api/assets`);
  }

  createAsset(asset: Asset) {
    return this.http.post(`${environment.baseUrl}/api/assets`, asset)
  }

  updateAsset(id: string,result: any) {
    let data = {
      owner: result.owner,
      color: result.color,
      size: result.size,
      appraisedValue: result.appraisedValue
    }
    return this.http.put(`${environment.baseUrl}/api/assets/${id}`, data)
  }

  getHistory(id: string): Observable<History[]> {
    return this.http.get<History[]>(`${environment.baseUrl}/api/assets/${id}`);
  }

  deleteAsset(id: string) {
    return this.http.delete(`${environment.baseUrl}/api/assets/${id}`)
  }
}
