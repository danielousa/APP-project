import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/internal/Observable';
import { TipoUtilizador } from '../models/tipo-utilizador';

@Injectable({
  providedIn: 'root'
})
export class TipoUtilizadorService {

  private apiUrl = `${environment.ApiUrl}TipoUtilizadors`

  constructor(private http: HttpClient) { }
  //GetAll
  async GetTipoUtilizador(): Promise<Observable<TipoUtilizador[]>> {
    return await this.http.get<TipoUtilizador[]>(this.apiUrl);
  }

  //GetByID
  GetIdTipoUtilizador(IdTipoUtilizador: number): Observable<TipoUtilizador> {
    return this.http.get<TipoUtilizador>(`${this.apiUrl}/${IdTipoUtilizador}`);
  }

  //Create
  CreateTipoUtilizador(tipoUtilizador: TipoUtilizador): Observable<TipoUtilizador[]> {
    return this.http.post<TipoUtilizador[]>(`${this.apiUrl}`, tipoUtilizador);
  }

  //Update
  UpdateTipoUtilizador(IdTipoUtilizador: number, tipoUtilizador: TipoUtilizador): Observable<TipoUtilizador[]> {
    return this.http.put<TipoUtilizador[]>(`${this.apiUrl}/${IdTipoUtilizador}`, tipoUtilizador);
  }

  //Delete
  DeleteTipoUtilizador(IdTipoUtilizador: number): Observable<any> {
    return this.http.delete<TipoUtilizador>(`${this.apiUrl}/${IdTipoUtilizador}`);
  }

}
