import { Component } from '@angular/core';
import { TipoUtilizador } from '../../models/tipo-utilizador';
import { TipoUtilizadorService } from '../../services/tipo-utilizador.service';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-create-tipo-utilizador',
  templateUrl: './create-tipo-utilizador.component.html',
  styleUrl: './create-tipo-utilizador.component.css'
})
export class CreateTipoUtilizadorComponent {

  btnAcao = "Confirmar"
  btnTitulo = "Registar novo TipoUtilizador"
  tipoUtilizador: TipoUtilizador;
  createForm: FormGroup;

  constructor(
    private tipoUtilizadorService: TipoUtilizadorService,
    private router: Router,
    private form: FormBuilder,
    private route: ActivatedRoute
  ) {


    this.createForm = this.form.group({
      idTipoUtilizador: [0, [Validators.required]],
      Designacao: ['', [Validators.required]]
    })

    this.tipoUtilizador = {
      idTipoUtilizador: 0,
      designcacao: ''
    }



  }


  criarTipoUtilizador() {

    if (!this.tipoUtilizador.designcacao.trim()) {
      alert('Por favor, preencha o campo Nome.');
      return;
    }
    console.log(this.tipoUtilizador);

    console.log(this.tipoUtilizador);
    this.tipoUtilizadorService.CreateTipoUtilizador(this.tipoUtilizador).subscribe(data => {
      console.log('Tipo de Utilizador adicionado com sucesso', data);
      alert("Tipo de Utilizador adicionado");
      console.log('Tipo de utilizador adicionado com sucesso', data)
      this.createForm.reset();
      this.tipoUtilizador = { idTipoUtilizador: 0, designcacao: '' };
      this.router.navigate(['/'])
    }, error => {
      console.log('Tipo de Utilizador não pode ser criada', error);
      alert("Tipo de Utilizador não pode ser adicionada");
    });


  }


}
