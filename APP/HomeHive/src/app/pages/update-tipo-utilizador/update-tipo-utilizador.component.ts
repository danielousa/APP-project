import { Component, OnInit } from '@angular/core';
import { TipoUtilizador } from '../../models/tipo-utilizador';
import { TipoUtilizadorService } from '../../services/tipo-utilizador.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';


@Component({
  selector: 'app-update-tipo-utilizador',
  templateUrl: './update-tipo-utilizador.component.html',
  styleUrl: './update-tipo-utilizador.component.css'
})

export class UpdateTipoUtilizadorComponent implements OnInit {

  btnAcao: string = 'Update'
  btnTitulo: string = 'Update TipoUtilizador'
  tipoUtilizador: TipoUtilizador;
  updateForm: FormGroup;

  constructor(
    private tipoUtilizadorService: TipoUtilizadorService,
    private route: ActivatedRoute,
    private router: Router,
    private form: FormBuilder
  ) {

    this.updateForm = this.form.group({
      Designacao: ['', [Validators.required]]
    })

    this.tipoUtilizador = {
      idTipoUtilizador: 0,
      designcacao: '',
      dataAtualizacao: '',
      dataCriacao: ''
    }
  }


  ngOnInit(): void {
    const idTipoUtilizador = Number(this.route.snapshot.paramMap.get('IdTipoUtilizador'));
    console.log('IdTipoUtilizador:', idTipoUtilizador);

    this.tipoUtilizadorService.GetIdTipoUtilizador(idTipoUtilizador).subscribe((data) => {
      console.log('Data recebida do serviço:', data);

      this.tipoUtilizador = data;
    });
  }

  updateTipoUtilizador() {
    //console.log(tipoUtilizador)
    console.log(this.tipoUtilizador.idTipoUtilizador)
    //const id = this.tipoUtilizador.idTipoUtilizador;
    console.log('o meu id é:' + this.tipoUtilizador.idTipoUtilizador)
    this.tipoUtilizadorService.UpdateTipoUtilizador(this.tipoUtilizador.idTipoUtilizador, this.tipoUtilizador).subscribe((data) => {
      this.router.navigate(['/'])
    })

  }

}
