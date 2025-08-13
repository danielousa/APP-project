import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { TipoUtilizador } from '../../models/tipo-utilizador';

@Component({
  selector: 'app-tipo-utilizador-form',
  templateUrl: './tipo-utilizador-form.component.html',
  styleUrl: './tipo-utilizador-form.component.css'
})
export class TipoUtilizadorFormComponent implements OnInit {
  @Output() onSubmit = new EventEmitter<TipoUtilizador>();
  @Input() btnAcao!: string;
  @Input() btnTitulo!: string;
  @Input() dataTipoUtilizador: TipoUtilizador | null = null;

  tipoUtilizadorForm!: FormGroup;


  constructor() { }

  ngOnInit(): void {

    this.tipoUtilizadorForm = new FormGroup({
      Designcacao: new FormControl(
        this.dataTipoUtilizador ? this.dataTipoUtilizador.designcacao : '', [Validators.required])

    });

  }

  submit() {

    this.onSubmit.emit(this.tipoUtilizadorForm.value);

  }

}
