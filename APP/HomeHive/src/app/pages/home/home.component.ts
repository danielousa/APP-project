import { Component, OnInit } from '@angular/core';
import { TipoUtilizadorService } from '../../services/tipo-utilizador.service';
import { TipoUtilizador } from '../../models/tipo-utilizador';
import { Observable } from 'rxjs/internal/Observable';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent implements OnInit {

  tipoUtilizadores: TipoUtilizador[] = [];

  constructor(private tipoUtilizadorService: TipoUtilizadorService) { }

  ngOnInit(): void {

    this.tipoUtilizadorService.GetTipoUtilizador().then((data: Observable<TipoUtilizador[]>) => {
      data.subscribe(list => {
        console.log(list);
        this.tipoUtilizadores = list;
      });

    }).catch(error => {
      console.log(error);
    })

  }

}









