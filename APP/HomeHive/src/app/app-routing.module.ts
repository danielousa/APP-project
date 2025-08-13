import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { CreateTipoUtilizadorComponent } from './pages/create-tipo-utilizador/create-tipo-utilizador.component';
import { HomeComponent } from './pages/home/home.component';
import { UpdateTipoUtilizadorComponent } from './pages/update-tipo-utilizador/update-tipo-utilizador.component';
import { DeleteTipoUtilizadorComponent } from './componentes/delete-tipo-utilizador/delete-tipo-utilizador.component';

const routes: Routes = [
  { path: 'create-tipo-utilizador', component: CreateTipoUtilizadorComponent },
  { path: '', component: HomeComponent },
  { path: 'update-tipo-utilizador/:IdTipoUtilizador', component: UpdateTipoUtilizadorComponent },
  { path: 'delete-tipo-utilizador/:IdTipoUtilizador', component: DeleteTipoUtilizadorComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {

}
