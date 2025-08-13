import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpdateTipoUtilizadorComponent } from './update-tipo-utilizador.component';

describe('UpdateTipoUtilizadorComponent', () => {
  let component: UpdateTipoUtilizadorComponent;
  let fixture: ComponentFixture<UpdateTipoUtilizadorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [UpdateTipoUtilizadorComponent]
    })
      .compileComponents();

    fixture = TestBed.createComponent(UpdateTipoUtilizadorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
