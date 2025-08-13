import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { TipoUtilizador } from '../../models/tipo-utilizador';
import { TipoUtilizadorService } from '../../services/tipo-utilizador.service';

@Component({
  selector: 'app-delete-tipo-utilizador',
  templateUrl: './delete-tipo-utilizador.component.html',
  styleUrl: './delete-tipo-utilizador.component.css'
})
export class DeleteTipoUtilizadorComponent implements OnInit {

  tipoUtilizador: TipoUtilizador;
  deleteForm: FormGroup;

  constructor(
    private tipoUtilizadorService: TipoUtilizadorService,
    private route: ActivatedRoute,
    private router: Router,
    private form: FormBuilder
  ) {

    this.deleteForm = this.form.group({
      idTipoUtilizador: [0, [Validators.required]]
    })

    this.tipoUtilizador = {
      idTipoUtilizador: 0,
      designcacao: ''

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


  delete() {

    //console.log(tipoUtilizador)
    console.log(this.tipoUtilizador.idTipoUtilizador)
    //const id = this.tipoUtilizador.idTipoUtilizador;
    console.log('o meu id é:' + this.tipoUtilizador.idTipoUtilizador)
    alert('Tipo de utilizador eliminado com sucesso')
    this.tipoUtilizadorService.DeleteTipoUtilizador(this.tipoUtilizador.idTipoUtilizador ?? 0).subscribe((data) => {
      this.router.navigate(['/'])
      console.log(data)
    })

  }

}
