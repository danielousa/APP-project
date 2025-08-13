import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './pages/home/home.component';
import { HttpClientModule } from '@angular/common/http';
import { CreateTipoUtilizadorComponent } from './pages/create-tipo-utilizador/create-tipo-utilizador.component';
import { TipoUtilizadorFormComponent } from './componentes/tipo-utilizador-form/tipo-utilizador-form.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { UpdateTipoUtilizadorComponent } from './pages/update-tipo-utilizador/update-tipo-utilizador.component';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { DeleteTipoUtilizadorComponent } from './componentes/delete-tipo-utilizador/delete-tipo-utilizador.component';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    CreateTipoUtilizadorComponent,
    TipoUtilizadorFormComponent,
    UpdateTipoUtilizadorComponent,
    DeleteTipoUtilizadorComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule
  ],
  providers: [
    provideAnimationsAsync()
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
